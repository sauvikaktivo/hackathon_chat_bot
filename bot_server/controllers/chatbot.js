const { nlpAnalyse } = require('../controllers/nlp/awscomprehend')
const {processNLPResult, BotTasksType } = require('../controllers/botTaskGenerator')
const { messageGenerator } = require('../controllers/botMessageGenerator')
const { quickActionGenerator } = require('../controllers/botQuickActionGenerator')
const { botSDUIGenerator } = require('../controllers/botSDUIGenerator')

const { response } = require('express')

const requestNext = async(req, res) => {
    console.log(req.body)
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
                        message: `Sorry I could not understand: ${reqData.query}, try something else.`
                    }
                }
                const messages = messageGenerator(botTask)
                const quickActions = quickActionGenerator(botTask)
                res.json({
                    messages: messages,
                    quickActions: quickActions
                })
            } else {
                const botTask = processNLPResult(reqData.query, data)
                const messages = messageGenerator(botTask)
                const quickActions = quickActionGenerator(botTask)
                res.json({
                    messages: messages,
                    quickActions: quickActions.length > 0 ? quickActions : null
                })
            }
        })
        return
    }

    // User selected predefined action
    if (requestCode === 'dayFirstLaunch') {
        const botTask = {
            task: BotTasksType.DAY_FIRST_LAUNCH_OPTION,
        }
        const messages = messageGenerator(botTask)
        const quickActions = quickActionGenerator(botTask)
        res.json({
            layout:  botSDUIGenerator(botTask),
            messages: messages,
            quickActions: quickActions.length > 0 ? quickActions : null
        })
        return
    }

    // User selected predefined action
    if (requestCode === 'quickAction') {
        const botTask = {
            task: reqData.botTaskId,
        }
        const messages = messageGenerator(botTask)
        const quickActions = quickActionGenerator(botTask)
        res.json({
            messages: messages,
            layout:  botSDUIGenerator(botTask),
            quickActions: quickActions.length > 0 ? quickActions : null
        })
        return
    }

    // Error response
    res.send('I am going to serve you in a much better way. IN FUTURE...:)')
}

module.exports = {
    requestNext,
}