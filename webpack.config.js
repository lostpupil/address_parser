var path = require('path');

module.exports = {
    context: path.resolve(__dirname, 'src'),
    entry: './index.js',
    output: {
        filename: 'bundle.js',
        path: path.resolve(__dirname, 'public/dist')
    },
    module: {
        loaders: [{
            test: /\.jsx?$/, // 匹配'js' or 'jsx' 后缀的文件类型
            exclude: /(node_modules|bower_components)/, // 排除某些文件
            loader: 'babel-loader', // 使用'babel-loader'也是一样的
            query: { // 参数
                presets: ['es2015']
            }
        }]
    }
};