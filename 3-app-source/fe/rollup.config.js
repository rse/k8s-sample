/*
**  k8s-sample -- Kubernetes Sample Application
**  Copyright (c) 2019-2020 Dr. Ralf S. Engelschall <rse@engelschall.com>
**  Distributed under MIT license <https://spdx.org/licenses/MIT.html>
*/

import vue         from "rollup-plugin-vue"
import commonjs    from "@rollup/plugin-commonjs"
import replace     from "@rollup/plugin-replace"
import eslint      from "@rollup/plugin-eslint"
import bundleSize  from "rollup-plugin-filesize"
import resolve     from "@rollup/plugin-node-resolve"
import globals     from "rollup-plugin-node-globals"
import postcss     from "rollup-plugin-postcss"
import babel       from "@rollup/plugin-babel"
import url         from "@rollup/plugin-url"
import { terser }  from "rollup-plugin-terser"
import html        from "rollup-plugin-generate-html"
import postcssUrl  from "postcss-url"

export default {
    external:      [],
    context:       "window",
    moduleContext: "window",
    plugins: [
        eslint({
            extensions:   [ ".js", ".vue" ],
            exclude:      [ "**/*.json", "**/*.css", "**/*.jpg", "**/*.png", "**/*.svg" ],
            cache:        true,
            throwOnError: true,
            useEslintrc:  true,
            configFile:   "eslint.yaml"
        }),
        resolve({
            browser: true
        }),
        url(),
        commonjs(),
        replace({
            "process.env.NODE_ENV": JSON.stringify(process.env.NODE_ENV)
        }),
        vue({
            template: {
                isProduction: process.env.NODE_ENV === "production",
                compilerOptions: { preserveWhitespace: false }
            },
            css: false
        }),
        postcss({
            plugins: [
                postcssUrl({
                    url:        "copy",
                    basePath:   "",
                    assetsPath: "",
                    useHash:    true
                })
            ],
            extract: true,
            minimize: false,
            to: "dst/app.css",
        }),
        globals(),
        babel({
            babelrc: false,
            babelHelpers: "runtime",
            include: [
                "./src/**"
            ],
            exclude: [
                "node_modules/**"
            ],
            presets: [
                [ "@babel/preset-env", {
                    targets: { ie: 9 },
                    modules: false
                } ],
            ],
            plugins: [
                [ "@babel/plugin-transform-runtime", {
                    corejs: 3,
                    helpers: true,
                    regenerator: true,
                    useESModules: false,
                    absoluteRuntime: false
                } ]
            ]
        }),
        (process.env.NODE_ENV === "production" && terser()),
        bundleSize(),
        html({
            template: "src/app.html",
            filename: "dst/index.html"
        })
    ],
    input:      "src/app.js",
    output: {
        globals: {},
        file:   "dst/app.js",
        format: "umd"
    }
}

