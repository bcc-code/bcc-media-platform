import { SwiperOptions } from "swiper"

const spaceBetween = 10

export default (size: "small" | "medium") => {
    switch (size) {
        case "small":
            return {
                0: {
                    slidesPerView: 2.5,
                    spaceBetween,
                },
                1280: {
                    slidesPerView: 6.5,
                    spaceBetween,
                },
                1920: {
                    slidesPerView: 9.5,
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
                    slidesPerView: 4.33,
                    spaceBetween,
                },
                1920: {
                    slidesPerView: 6.5,
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
                    slidesPerView: 4.5,
                    spaceBetween,
                },
                1920: {
                    slidesPerView: 6.5,
                    spaceBetween,
                },
            } as {
                [key: number]: SwiperOptions
            }
    }
}
