const setTitle = (title: string) => {
    if (title) {
        document.title = "BrunstadTV - " + title
    } else {
        document.title = "BrunstadTV"
    }
}

export const useTitle = () => {
    return {
        setTitle
    }
}