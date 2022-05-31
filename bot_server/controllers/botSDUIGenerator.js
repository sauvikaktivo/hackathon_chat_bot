const { getDayFirstLaunchUI, getAddWeightUI } = require('../SDUIs/DayFirstLaunchUI')
const {processNLPResult, BotTasksType } = require('../controllers/botTaskGenerator')

const botSDUIGenerator = (botTask) => {
    if (botTask.task === BotTasksType.WEIGHT_INFO) {
        return null
    } else if (botTask.task === BotTasksType.ADD_WEIGHT) {
        return getAddWeightUI()
    } else if (botTask.task === BotTasksType.SLEEP_INFO) {
        return null
    } else if (botTask.task === BotTasksType.DAY_FIRST_LAUNCH_OPTION) {
        return getDayFirstLaunchUI()
    } else {
        return null
    }
}

module.exports = {
    botSDUIGenerator
}