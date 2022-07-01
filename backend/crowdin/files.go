package crowdin

import (
	"encoding/json"
	"fmt"
	"github.com/bcc-code/mediabank-bridge/log"
	"strconv"
)

type addStringRequest struct {
	Text       string `json:"text"`
	Identifier string `json:"identifier"`
	FileId     int    `json:"fileId"`
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
	Value any    `json:"value"`
	Op    string `json:"op"`
	Path  string `json:"path"`
}

type storageCreateResponse struct {
	ID       int    `json:"id"`
	FileName string `json:"fileName"`
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

func (client *Client) getTranslations(projectId int, fileId int, language string) ([]Translation, error) {
	return incrementallyRetrieve(func(limit int, offset int) ([]Translation, error) {
		return getItems[Translation](client, fmt.Sprintf("projects/%d/languages/%s/translations", projectId, language), limit, offset, map[string]string{
			"fileId": strconv.Itoa(fileId),
		})
	})
}

func (client *Client) getStrings(projectId int, fileId int) ([]String, error) {
	return incrementallyRetrieve(func(limit int, offset int) ([]String, error) {
		return getItems[String](client, fmt.Sprintf("projects/%d/strings", projectId), limit, offset, map[string]string{
			"fileId": strconv.Itoa(fileId),
		})
	})
}

func (client *Client) getFiles(projectId int, directoryId int) ([]File, error) {
	return incrementallyRetrieve(func(limit int, offset int) ([]File, error) {
		return getItems[File](client, fmt.Sprintf("projects/%d/files", projectId), limit, offset, map[string]string{
			"directoryId": strconv.Itoa(directoryId),
		})
	})
}

func (client *Client) getDirectories(projectId int) ([]Directory, error) {
	return incrementallyRetrieve(func(limit int, offset int) ([]Directory, error) {
		return getItems[Directory](client, fmt.Sprintf("projects/%d/directories", projectId), limit, offset, nil)
	})
}

func (client *Client) setString(projectId int, s String) (r String, err error) {
	req := client.c.R()
	req.SetBody([]patchRequest{
		{
			Value: s.Text,
			Op:    "replace",
			Path:  "/text",
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
	return
}

func (client *Client) addString(projectId int, fileId int, s String) (r String, err error) {
	req := client.c.R()
	req.SetBody(addStringRequest{
		Identifier: s.Identifier,
		Text:       s.Text,
		FileId:     fileId,
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

func (client *Client) addStrings(projectId int, fileId int, strings []String) error {
	for _, s := range strings {
		_, err := client.addString(projectId, fileId, s)
		if err != nil {
			return err
		}
	}
	return nil
}

func (client *Client) createFile(projectId int, directoryId int, title string, initialStrings []String) (file File, err error) {
	content := ""
	for _, s := range initialStrings {
		identifier, _ := json.Marshal(s.Identifier)
		text, _ := json.Marshal(s.Text)
		content += fmt.Sprintf("%s,%s\n", identifier, text)
	}
	req := client.c.R()
	req.SetHeader("Crowdin-API-FileName", fmt.Sprintf("%s.csv", title))
	req.SetBody(content)
	req.SetResult(Object[storageCreateResponse]{})
	res, err := req.Post("storages")
	if err != nil {
		log.L.Error().Err(err).Msg("Failed to create storage file")
		return
	}
	storage := res.Result().(*Object[storageCreateResponse]).Data

	req = client.c.R()
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
	return res.Result().(*Object[File]).Data, nil
}
