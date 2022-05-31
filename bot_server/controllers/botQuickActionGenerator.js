const {processNLPResult, BotTasksType } = require('../controllers/botTaskGenerator')

const quickActionGenerator = (botTask) => {
    if (botTask.task === BotTasksType.WEIGHT_INFO) {
        return [
            { buttonTitle: 'Modify', botTaskId: BotTasksType.ADD_WEIGHT },
            { buttonTitle: 'My weight is same', botTaskId: BotTasksType.NO_ACTION },
        ]
    } else if (botTask.task === BotTasksType.ADD_WEIGHT) {
        return [
            { buttonTitle: 'Save', botTaskId: BotTasksType.SAVE_WEIGHT },
        ]
    } else if (botTask.task === BotTasksType.SLEEP_INFO) {
        return [
            { buttonTitle: 'Modify', botTaskId: BotTasksType.UPDATE_LAST_NIGHT_SLEEP },
            { buttonTitle: 'I slept in my sleep zone', botTaskId: BotTasksType.NO_ACTION },
        ]
    } else if (botTask.task === BotTasksType.DAY_FIRST_LAUNCH_OPTION) {
        return [
            { buttonTitle: 'Add Weight', botTaskId: BotTasksType.WEIGHT_INFO },
            { buttonTitle: 'Show Mind Article', botTaskId: BotTasksType.SHOW_MIND_ARTICLE },
        ]
    } else {
        return []
    }
}

module.exports = {
    quickActionGenerator,
}