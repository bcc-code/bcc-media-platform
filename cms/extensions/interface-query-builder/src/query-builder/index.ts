import { Filter, Group } from "./types";

export * from "./types";

export const snakeToPascal = (string: string) => {
    return string.split("/")
        .map(snake => snake.split("_")
            .map(substr => substr.charAt(0)
                .toUpperCase() +
                substr.slice(1))
            .join(""))
        .join("/");
};

export const groupOperators = ["and", "or"];

export const isGroup = (item: Filter | Group) => {
    const operator = Object.keys(item)[0];
    if (operator && groupOperators.includes(operator)) {
        return true;
    }
    return false;
}

export const filterOperators = [
    "==",
    "!=",
    "<",
    "<=",
    ">",
    ">=",
    "in",
    "is",
    "!is"
]

export const isFilter = (item: Filter | Group) => {
    const operator = Object.keys(item)[0];
    if (operator && filterOperators.includes(operator)) {
        return true;
    }
    return false;
}
