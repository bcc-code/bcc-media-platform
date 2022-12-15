import { Converter } from "showdown"

const mdConverter = new Converter({})

export const mdToHTML = (md: string) => {
    return mdConverter.makeHtml(md)
}
