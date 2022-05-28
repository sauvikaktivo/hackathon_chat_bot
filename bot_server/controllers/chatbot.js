const {detectKeyPhrases} = require('../controllers/nlp/awscomprehend')

const requestNext = async(req, res) => {
    const requestCode = req.body.request.code
    const requestVersion = req.body.request.version
    const reqData = req.body.request.data

    // Sanity check
    if (requestCode === null || requestVersion === null) {
        res.statuscode = 400
        res.json({
            error: "INVALID_REQUEST",
            message: `Could not find request code or request version`
        })
        return
    }
    if (requestCode === 'typedText' && reqData.query !== null ) {
        const result = await detectKeyPhrases(reqData.query, (error, data) => {
            if(data) {
                res.json(data)
            } else {
                res.json(err)
            }
        })
        return
    }
    res.send('I am going to serve you in a much better way')
}


module.exports = {
    requestNext,
}