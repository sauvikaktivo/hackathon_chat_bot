const {processNLPResult, BotTasksType } = require('../controllers/botTaskGenerator')
const {DateToString}= require('../utils/utils')

const messageGenerator = (botTask) => {
    if (botTask === null || botTask.task === BotTasksType.REPORT_ERROR) {
        // Generate Error Message
        return [
            {
                message: `Sorry I could not understand, try something else. \"Add weight\" or \"Enter weight\"`,
                createdAt: DateToString()
            }
        ]
    }
    if (botTask.task === BotTasksType.WEIGHT_INFO) {
        const messages = []
        WeightInfoMessages.forEach( (msg) => {
            messages.push({
                message: msg,
                createdAt: DateToString()
            })
        })
        return messages
    } else if (botTask.task === BotTasksType.SAVE_WEIGHT) {
        return [
            {
                message: WeightSaveMessage[0],
                createdAt: DateToString()
            }
        ]
    } else if (botTask.task === BotTasksType.SLEEP_INFO) {
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
    } else if (botTask.task === BotTasksType.ADD_WEIGHT) {
        const messages = []
        AddWeightMessages.forEach( (msg) => {
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
                message: `Sorry I could not understand, try something else. \"Add weight\" or \"Enter weight\"`,
                createdAt: DateToString()
            }
        ]
    }
}

const WeightInfoMessages = [
    'Hi John',
    'Hope you are doing well',
    'We have your last updated weight of 75kg. Do you want to modify?'
]
const AddWeightMessages = [
    'Please enter your present weight.'
]
const WeightSaveMessage = [
    'Weight updated'
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