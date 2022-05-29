const { nlpAnalyse } = require('../controllers/nlp/awscomprehend')
const {processNLPResult, BotTasksType } = require('../controllers/botTaskGenerator')
const { messageGenerator } = require('../controllers/botMessageGenerator')
const { response } = require('express')

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

    // User typed something
    if (requestCode === 'typedText' && reqData.query !== null ) {
        nlpAnalyse(reqData.query, (err, data) => {
            if(err) {
                const botTask = {
                    task: BotTasksType.REPORT_ERROR,
                    data: {
                        message: `Sorry I could not understand: ${reqData.query}, try something else`
                    }
                }
                res.json(messageGenerator(botTask))
            } else {
                const botTask = processNLPResult(data)
                // Determinde messages for bot task to send
                res.json(messageGenerator(botTask))
            }
        })
        return
    }

    // User selected predefined action
    if (requestCode === 'dayFirstLaunch') {
        res.json(messageGenerator({
            task: BotTasksType.DAY_FIRST_LAUNCH_OPTION,
        }))
        return
    }

    // Error response
    res.send('I am going to serve you in a much better way')
}

module.exports = {
    requestNext,
}