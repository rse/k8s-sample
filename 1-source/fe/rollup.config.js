/*
**  Sample -- Sample Application
**  Copyright (c) 2019 Dr. Ralf S. Engelschall <rse@engelschall.com>
**  Distributed under MIT license <https://spdx.org/licenses/MIT.html>
*/

import vue         from "rollup-plugin-vue"
import commonjs    from "rollup-plugin-commonjs"
import replace     from "rollup-plugin-replace"
import { eslint }  from "rollup-plugin-eslint"
import bundleSize  from "rollup-plugin-filesize"
import resolve     from "rollup-plugin-node-resolve"
import globals     from "rollup-plugin-node-globals"
import css         from "rollup-plugin-css-only"
import babel       from "rollup-plugin-babel"
import { terser }  from "rollup-plugin-terser"
import html        from "rollup-plugin-generate-html"

export default {
    external:      [],
    context:       "window",
    moduleContext: "window",
    plugins: [
        resolve({
            browser: true
        }),
        commonjs(),
        replace({
            "process.env.NODE_ENV": JSON.stringify(process.env.NODE_ENV)
        }),
        css({ output: "dst/app.css" }),
        eslint({
            extensions:   [ ".js", ".vue" ],
            exclude:      [ "**/*.json" ],
            cache:        true,
            throwOnError: true,
            useEslintrc:  false,
            configFile:   "eslint.yaml"
        }),
        vue({
            template: {
                isProduction: process.env.NODE_ENV === "production",
                compilerOptions: { preserveWhitespace: false }
            },
            css: false
        }),
        globals(),
        babel({
		    babelrc: false,
            runtimeHelpers: true,
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

