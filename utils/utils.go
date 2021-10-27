package utils

import "strconv"

func StringArrayToIntArray(t []string) ([]int, error) {
	// https://stackoverflow.com/a/24973010
	var t2 = []int{}

	for _, i := range t {
		j, err := strconv.Atoi(i)
		if err != nil {
			return nil, err
		}
		t2 = append(t2, j)
	}
	return t2, nil
}
