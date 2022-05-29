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
                    imageUrl: '/public/resources/icons/add_weight.png',
                    botTaskId: BotTasksType.ADD_WEIGHT
                },
                {
                    title: 'Exercise',
                    imageUrl: '/public/resources/icons/exercise.png',
                    botTaskId: BotTasksType.EXERCISE_INFO
                },
                {
                    title: 'Meditaion',
                    imageUrl: '/public/resources/icons/meditaion.png',
                    botTaskId: BotTasksType.MEDITATION_INFO
                },
                {
                    title: 'Mind Article',
                    imageUrl: '/public/resources/icons/mind_article.png',
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


module.exports = {
    getDayFirstLaunchUI,
}