export default function (a, b, c, d) {
    return function () {
        d = this
        clearTimeout(c)
        c = setTimeout(function () {
            a.apply(d, arguments)
        }, b || 100)
    }
}
