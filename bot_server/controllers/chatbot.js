const requestNext = (req, res) => {
    console.log("========HEADERS=============")
    console.log(req.headers)
    console.log("========HEADERS ENDS=============")

    console.log("========PARAMS=============")
    console.log(req.params)
    console.log("========PARAMS ENDS=============")

    console.log("========QUERY=============")
    console.log(req.query)
    console.log("========QUERY ENDS=============")

    console.log("========BODY=============")
    console.log(req.body)
    console.log("========QUERY ENDS=============")


    res.send('I am going to serve you in a much better way')
}

module.exports = {
    requestNext,
}