import { SwiperOptions } from "swiper"

const spaceBetween = 15

export default (size: "small" | "medium") => {
    switch (size) {
        case "small":
            return {
                0: {
                    slidesPerView: 2.5,
                    spaceBetween,
                },
                1280: {
                    slidesPerView: 6,
                    spaceBetween,
                },
                1920: {
                    slidesPerView: 9,
                    spaceBetween,
                },
            } as {
                [key: number]: SwiperOptions
            }
        case "medium":
            return {
                0: {
                    slidesPerView: 1.5,
                    spaceBetween,
                },
                1280: {
                    slidesPerView: 4,
                    spaceBetween,
                },
                1920: {
                    slidesPerView: 6,
                    spaceBetween,
                },
            } as {
                [key: number]: SwiperOptions
            }
        default:
            return {
                0: {
                    slidesPerView: 1.5,
                    spaceBetween,
                },
                1280: {
                    slidesPerView: 4,
                    spaceBetween,
                },
                1920: {
                    slidesPerView: 6,
                    spaceBetween,
                },
            } as {
                [key: number]: SwiperOptions
            }
    }
}
