package utils

import "strconv"

// StringArrayToIntArray uses Atoi to convert strings to ints
func StringArrayToIntArray(t []string) ([]int, error) {
	// https://stackoverflow.com/a/24973010
	t2 := make([]int, 0, len(t))

	for _, i := range t {
		j, err := strconv.Atoi(i)
		if err != nil {
			return nil, err
		}
		t2 = append(t2, j)
	}
	return t2, nil
}
