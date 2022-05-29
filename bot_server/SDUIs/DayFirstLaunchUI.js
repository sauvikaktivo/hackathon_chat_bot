const { BotTasksType } = require('../controllers/botTaskGenerator')
const getDayFirstLaunchUI = () => { return DayFirstLaunchUI }
const DayFirstLaunchUI = {
    id: 'some_random_uuid',
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
                    imageUrl: '/resources/icons/add_weight.png',
                    botTaskId: BotTasksType.ADD_WEIGHT
                },
                {
                    title: 'Exercise',
                    imageUrl: '/resources/icons/exercise.png',
                    botTaskId: BotTasksType.EXERCISE_INFO
                },
                {
                    title: 'Meditaion',
                    imageUrl: '/resources/icons/meditaion.png',
                    botTaskId: BotTasksType.MEDITATION_INFO
                },
                {
                    title: 'Mind Article',
                    imageUrl: '/resources/icons/mind_article.png',
                    botTaskId: BotTasksType.SHOW_MIND_ARTICLE
                },
                {
                    title: 'Fibre Score',
                    imageUrl: '/resources/icons/fibre_score.png',
                    botTaskId: BotTasksType.FIBRE_SCORE
                },
                {
                    title: 'Log Food',
                    imageUrl: '/resources/icons/log_food.png',
                    botTaskId: BotTasksType.LOG_FOOD
                },
                {
                    title: 'Mind Score',
                    imageUrl: '/resources/icons/mind_score.png',
                    botTaskId: BotTasksType.MIND_SCORE_INFO
                }
            ]
        }
    }

}


module.exports = {
    getDayFirstLaunchUI,
}