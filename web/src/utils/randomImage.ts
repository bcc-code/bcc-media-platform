export const randomImageUrl = () => {
    const filenames = [
        "7d9ecca8-6111-4f95-8fb6-55aacf8cf2eb.jpg",
        "63fa8607-a8df-42d0-a80a-ece978cd8714.jpg",
        "a35dffff-24aa-4a8e-9f5c-d5b55ce2a5bb.jpg",
        "0d52b6fd-f2b3-4120-9b44-7c2a6bf15d98.jpg",
        "02f44855-ca8c-48ac-9c63-083c9ae9e053.jpg",
        "340f7caa-43eb-4700-bd69-edc1ad18d143.jpg",
        "c7b34d9c-d961-4326-9686-d480d461b54c.jpg",
        "e51ba4d5-34f2-4b6c-9ede-97520604c27e.jpg",
        "f4224f5e-d73b-42b0-816c-d348655a237d.jpg",
        "KIDS_MV_ET_RENT_HJERTE_MAS_NOR.mxf.jpg",
        "forbundsmodell.jpg"
    ]

    const index = Math.floor(Math.random() * filenames.length)

    return "https://brunstadtv.imgix.net/" + filenames[index]
}