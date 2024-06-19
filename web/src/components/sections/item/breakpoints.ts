import { SwiperOptions } from "swiper/types"

const spaceBetween = 20

export default (size: "small" | "medium") => {
    switch (size) {
        case "small":
            return {
                0: {
                    slidesPerView: 2.2,
                    spaceBetween: 10,
                    slidesPerGroup: 2,
                },
                1280: {
                    slidesPerView: 4.33,
                    spaceBetween,
                    slidesPerGroup: 4,
                },
                1920: {
                    slidesPerView: 6,
                    spaceBetween,
                    slidesPerGroup: 6,
                },
            } as {
                [key: number]: SwiperOptions
            }
        case "medium":
            return {
                0: {
                    slidesPerView: 1.5,
                    spaceBetween: 10,
                    slidesPerGroup: 1,
                },
                1280: {
                    slidesPerView: 4.33,
                    spaceBetween,
                    slidesPerGroup: 4,
                },
                1920: {
                    slidesPerView: 6,
                    spaceBetween,
                    slidesPerGroup: 6,
                },
            } as {
                [key: number]: SwiperOptions
            }
        default:
            return {
                0: {
                    slidesPerView: 1.5,
                    spaceBetween: 10,
                    slidesPerGroup: 1,
                },
                1280: {
                    slidesPerView: 4.5,
                    spaceBetween,
                    slidesPerGroup: 4,
                },
                1920: {
                    slidesPerView: 6.5,
                    spaceBetween,
                    slidesPerGroup: 6,
                },
            } as {
                [key: number]: SwiperOptions
            }
    }
}
