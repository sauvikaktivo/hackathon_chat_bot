const {processNLPResult, BotTasksType } = require('../controllers/botTaskGenerator')
const {DateToString}= require('../utils/utils')

const messageGenerator = (botTask) => {
    if (botTask.task === BotTasksType.ADD_WEIGHT) {
        const messages = []
        AddWeightMessages.forEach( (msg) => {
            messages.push({
                message: msg,
                createdAt: DateToString()
            })
        })
        return messages
    } else if (botTask.task === BotTasksType.ADD_SLEEP) {
        return [
            {
                message: AddSleepMessages[0],
                createdAt: DateToString()
            }
        ]
    } else if (botTask.task === BotTasksType.DAY_FIRST_LAUNCH_OPTION) {
        const messages = []
        AppLaunchMessages.forEach( (msg) => {
            messages.push({
                message: msg,
                createdAt: DateToString()
            })
        })
        return messages
    } else {
        // Generate Error Message
        return [
            {
                message: botTask.data.message,
                createdAt: DateToString()
            }
        ]
    }
}

const AddWeightMessages = [
    'Hi John',
    'Hope you are doing well',
    'We have your last updated weight of 75kg. Do you want to modify?'
]
const AppLaunchMessages = [
    'Great to see you back. You have few activities to complete today. Tap on above activies to start.'
]
const AddSleepMessages = [
    'Under development feature! Nice try!'
]

module.exports = {
    messageGenerator
}