const { BotTasksType } = require('../controllers/botTaskGenerator')
const getDayFirstLaunchUI = () => { return DayFirstLaunchUI }
const DayFirstLaunchUI = {
    id: 'some_random_uuid',
    type: 'firstLaunchGrid',
    layout: {
        text: {
            text: 'Today\'s Activities',
            type: 'Title'
        },
        grid: {
            colMax: 3,
            sizeType: 'equal',
            shape: 'square',
            items: [
                {
                    title: 'Add Weight',
                    imageUrl: '/public/resources/icons/add_weight.png',
                    botTaskId: BotTasksType.WEIGHT_INFO
                },
                {
                    title: 'Exercise',
                    imageUrl: '/public/resources/icons/exercise.png',
                    botTaskId: BotTasksType.EXERCISE_INFO
                },
                {
                    title: 'Meditaion',
                    imageUrl: '/public/resources/icons/meditation.png',
                    botTaskId: BotTasksType.MEDITATION_INFO
                },
                {
                    title: 'Mind Article',
                    imageUrl: '/public/resources/icons/mind_articles.png',
                    botTaskId: BotTasksType.SHOW_MIND_ARTICLE
                },
                {
                    title: 'Fibre Score',
                    imageUrl: '/public/resources/icons/fibre_score.png',
                    botTaskId: BotTasksType.FIBRE_SCORE
                },
                {
                    title: 'Log Food',
                    imageUrl: '/public/resources/icons/log_food.png',
                    botTaskId: BotTasksType.LOG_FOOD
                },
                {
                    title: 'Mind Score',
                    imageUrl: '/public/resources/icons/mind_score.png',
                    botTaskId: BotTasksType.MIND_SCORE_INFO
                }
            ]
        }
    }

}

const addWeightUI = {
    id: 'some_random_uuid',
    type: 'addWeightUI'
}
const getAddWeightUI = () => { return addWeightUI }

module.exports = {
    getDayFirstLaunchUI,
    getAddWeightUI,
}