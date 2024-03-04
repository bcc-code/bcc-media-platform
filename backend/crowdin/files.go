package crowdin

import (
	"fmt"
	"strconv"
	"time"

	cache "github.com/Code-Hex/go-generics-cache"
	"github.com/bcc-code/mediabank-bridge/log"
	"github.com/samber/lo"
)

type addStringRequest struct {
	Text       string `json:"text"`
	Identifier string `json:"identifier"`
	FileId     int    `json:"fileId"`
	Context    string `json:"context"`
}

type fileScheme struct {
	Identifier          int `json:"identifier"`
	SourceOrTranslation int `json:"sourceOrTranslation"`
}

type importOptions struct {
	Scheme             fileScheme `json:"scheme"`
	ImportTranslations bool       `json:"importTranslations"`
}

type addFileRequest struct {
	Name          string        `json:"name"`
	Title         string        `json:"title"`
	Type          string        `json:"type"`
	StorageID     int           `json:"storageId"`
	DirectoryID   int           `json:"directoryId"`
	ImportOptions importOptions `json:"importOptions"`
}

type patchRequest struct {
	Value any    `json:"value,omitempty"`
	Op    string `json:"op"`
	Path  string `json:"path"`
}

type storageCreateResponse struct {
	ID       int    `json:"id"`
	FileName string `json:"fileName"`
}

func getFromCacheOrIncrementallyRetrieve[K comparable, T any](cacheSource *cache.Cache[K, []T], key K, factory func(limit int, offset int) ([]T, error)) (result []T, err error) {
	if r, ok := cacheSource.Get(key); ok {
		return r, nil
	}
	result, err = incrementallyRetrieve(factory)
	if err == nil {
		cacheSource.Set(key, result, cache.WithExpiration(time.Minute*5))
	}
	return
}

func incrementallyRetrieve[T any](factory func(limit int, offset int) ([]T, error)) (result []T, err error) {
	resultLength := 0
	offset := 0
	limit := 100
	for {
		items, err := factory(limit, offset)
		if err != nil {
			return nil, err
		}

		resultLength = len(items)
		result = append(result, items...)

		if resultLength == limit {
			offset += limit
			continue
		}
		break
	}

	return
}

func (c *Client) getTranslations(projectId int, fileId int, language string) ([]Translation, error) {
	return incrementallyRetrieve(func(limit int, offset int) ([]Translation, error) {
		return getItems[Translation](c, fmt.Sprintf("projects/%d/languages/%s/translations", projectId, language), limit, offset, map[string]string{
			"fileId": strconv.Itoa(fileId),
		})
	})
}

func (c *Client) getApprovals(projectId int, fileId int, language string) ([]Approval, error) {
	return incrementallyRetrieve(func(limit int, offset int) ([]Approval, error) {
		return getItems[Approval](c, fmt.Sprintf("projects/%d/approvals", projectId), limit, offset, map[string]string{
			"fileId":     strconv.Itoa(fileId),
			"languageId": language,
		})
	})
}

func (c *Client) getStrings(projectId int, fileId int) ([]String, error) {
	return incrementallyRetrieve(func(limit int, offset int) ([]String, error) {
		return getItems[String](c, fmt.Sprintf("projects/%d/strings", projectId), limit, offset, map[string]string{
			"fileId": strconv.Itoa(fileId),
		})
	})
}

func (c *Client) getFiles(projectId int, directoryId int) ([]File, error) {
	return incrementallyRetrieve(func(limit int, offset int) ([]File, error) {
		return getItems[File](c, fmt.Sprintf("projects/%d/files", projectId), limit, offset, map[string]string{
			"directoryId": strconv.Itoa(directoryId),
		})
	})
}

var directoriesCache = cache.New[int, []Directory]()

func (c *Client) getDirectories(projectId int) ([]Directory, error) {
	return getFromCacheOrIncrementallyRetrieve(directoriesCache, projectId, func(limit int, offset int) ([]Directory, error) {
		return getItems[Directory](c, fmt.Sprintf("projects/%d/directories", projectId), limit, offset, nil)
	})
}

func (c *Client) hideStrings(projectID int, strs []String) error {
	chunks := lo.Chunk(strs, 20)
	for _, chunk := range chunks {
		req := c.c.R()
		req.SetHeader("Content-Type", "application/json")
		var body []patchRequest
		for _, str := range chunk {
			body = append(body, patchRequest{
				Op:    "replace",
				Path:  fmt.Sprintf("/%d/isHidden", str.ID),
				Value: true,
			})
		}
		req.SetResult(Object[[]Object[String]]{})
		req.SetBody(body)
		res, err := req.Patch(fmt.Sprintf("projects/%d/strings", projectID))
		if err != nil {
			return err
		}
		err = ensureSuccess(res)
		if err != nil {
			return err
		}
	}
	return nil
}

func (c *Client) unHideStrings(projectID int, strs []String) error {
	chunks := lo.Chunk(strs, 20)
	for _, chunk := range chunks {
		req := c.c.R()
		req.SetHeader("Content-Type", "application/json")
		var body []patchRequest
		for _, str := range chunk {
			body = append(body, patchRequest{
				Op:    "replace",
				Path:  fmt.Sprintf("/%d/isHidden", str.ID),
				Value: false,
			})
		}
		req.SetResult(Object[[]Object[String]]{})
		req.SetBody(body)
		res, err := req.Patch(fmt.Sprintf("projects/%d/strings", projectID))
		if err != nil {
			return err
		}
		err = ensureSuccess(res)
		if err != nil {
			return err
		}
	}
	return nil
}

func (c *Client) setString(projectId int, s String) (r String, err error) {
	req := c.c.R()
	req.SetBody([]patchRequest{
		{
			Value: s.Text,
			Op:    "replace",
			Path:  "/text",
		},
		{
			Value: s.Context,
			Op:    "replace",
			Path:  "/context",
		},
		{
			Value: s.IsHidden,
			Op:    "replace",
			Path:  "/isHidden",
		},
	})
	req.SetResult(Object[String]{})
	res, err := req.Patch(fmt.Sprintf("projects/%d/strings/%d", projectId, s.ID))
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to update string")
		return
	}
	err = ensureSuccess(res)
	if err == nil {
		r = res.Result().(*Object[String]).Data
	}
	project, err := c.getProject(projectId)
	if err != nil {
		return
	}
	for _, language := range project.TargetLanguages {
		req = c.c.R()
		req.SetResult(Result[[]Object[Approval]]{})
		req.SetQueryParams(map[string]string{
			"stringId":   strconv.Itoa(r.ID),
			"languageId": language.ID,
		})
		res, err = req.Get(fmt.Sprintf("projects/%d/approvals", project.ID))
		if err != nil {
			return
		}
		for _, approval := range res.Result().(*Result[[]Object[Approval]]).Data {
			req = c.c.R()
			_, err = req.Delete(fmt.Sprintf("projects/%d/approvals/%d", project.ID, approval.Data.ID))
			if err != nil {
				return
			}
		}
	}
	return
}

func (c *Client) addString(projectId int, fileId int, s String) (r String, err error) {
	req := c.c.R()
	req.SetBody(addStringRequest{
		Identifier: s.Identifier,
		Text:       s.Text,
		FileId:     fileId,
		Context:    s.Context,
	})
	req.SetResult(Object[String]{})
	res, err := req.Post(fmt.Sprintf("projects/%d/strings", projectId))
	if err != nil {
		log.L.Error().Err(err).Int("fileId", fileId).Msg("Failed to add string")
	}
	err = ensureSuccess(res)
	if err == nil {
		r = res.Result().(*Object[String]).Data
	}
	return
}

func (c *Client) addStrings(projectId int, fileId int, strings []String) error {
	for _, s := range strings {
		_, err := c.addString(projectId, fileId, s)
		if err != nil {
			return err
		}
	}
	return nil
}

func (c *Client) createFile(projectId int, directoryId int, title string, initialStrings []String) (file File, err error) {
	content := ""
	for _, s := range initialStrings {
		content += fmt.Sprintf("%s,%s\n", s.Identifier, "\""+crowdinString(s.Text)+"\"")
	}
	req := c.c.R()
	req.SetHeader("Crowdin-API-FileName", fmt.Sprintf("%s.csv", title))
	req.SetBody(content)
	req.SetResult(Object[storageCreateResponse]{})
	res, err := req.Post("storages")
	if err != nil {
		return
	}
	err = ensureSuccess(res)
	if err != nil {
		return
	}

	storage := res.Result().(*Object[storageCreateResponse]).Data

	req = c.c.R()
	req.SetBody(addFileRequest{
		Name:        title + ".csv",
		Title:       title,
		Type:        "csv",
		StorageID:   storage.ID,
		DirectoryID: directoryId,
		ImportOptions: importOptions{
			ImportTranslations: true,
			Scheme: fileScheme{
				Identifier:          0,
				SourceOrTranslation: 1,
			},
		},
	})
	req.SetResult(Object[File]{})
	res, err = req.Post(fmt.Sprintf("projects/%d/files", projectId))
	if err != nil {
		return
	}
	err = ensureSuccess(res)
	if err == nil {
		file = res.Result().(*Object[File]).Data
	}
	return
}
