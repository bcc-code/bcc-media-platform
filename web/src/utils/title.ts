export const setTitle = (title: string) => {
    if (title) {
        document.title = 'BCC Media - ' + title
    } else {
        document.title = 'BCC Media'
    }
}

export const useTitle = () => {
    return {
        setTitle,
    }
}
