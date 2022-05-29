// TODO: ML Based Processing 

const BotTasksType = {
    REPORT_ERROR: -1,

    // All weight module tasks
    WEIGHT_INFO: 0,
    ADD_WEIGHT: 1,
    // More task id for Weight module

    // All sleep module tasks
    SLEEP_INFO : 100,
    ADD_SLEEP: 101,
    UPDATE_LAST_NIGHT_SLEEP: 102,
    // More task id for sleep module

    // All Food module tasks
    FOOD_INFO : 200,
    LOG_FOOD: 201,
    FIBRE_SCORE: 202,
    // More task id for sleep module

    // Mind module
    MEDITATION_INFO: 300,
    SHOW_MIND_ARTICLE: 301,
    ADD_MIND_SCORE: 302,
    MIND_SCORE_INFO: 303,
    // Moe module task types

    // Exercise
    EXERCISE_INFO: 401,

    // UTILS
    DAY_FIRST_LAUNCH_OPTION: 100000,


    // NO ACTION
    NO_ACTION: 999999
}
const nplUserIntentMapper = [
    {
        keywords: ['add', 'weight'],
        intent: BotTasksType.WEIGHT_INFO
    },
    {
        keywords: ['add', 'sleep'],
        intent: BotTasksType.SLEEP_INFO
    },
    {
        keywords: ['enter', 'weight'],
        intent: BotTasksType.WEIGHT_INFO
    },
    {
        keywords: ['enter', 'sleep'],
        intent: BotTasksType.SLEEP_INFO
    }
]

const processNLPResult = (nlpResult) => {

    // TODO: Due implementation
    // 1. Process incoming nlp result to figure out next task type for BOT
    // 2. Extract associated data like date or other information. `nlpResult.entities` 
    // objects may come with type DATE

    // TODO: Add more note on PPT
    // SENTENCE SIMILARITY CHECK BERT ALGO
    // COUPLE OF AWS MARKET PLACE APPS

    return {
        task: BotTasksType.WEIGHT_INFO,
        data: {
            date: new Date()
        }
    }
    /*  In case of processing error passing error
    return {
        task: BotTasksType.REPORT_ERROR
    }
    */
}

module.exports = {
    processNLPResult,
    BotTasksType
}
/*
{
    "phrases": [
        {
            "text": "my weight",
            "score": 0.9999569654464722
        },
        {
            "text": "26th",
            "score": 0.988757312297821
        }
    ],
    "entities": [
        {
            "text": "26th may",
            "score": 0.9894523620605469,
            "type": "DATE"
        }
    ],
    "syntaxes": [
        {
            "tokenId": 1,
            "text": "want",
            "partOfSpeech": "VERB",
            "score": 0.995025634765625
        },
        {
            "tokenId": 2,
            "text": "to",
            "partOfSpeech": "PART",
            "score": 0.9999856948852539
        },
        {
            "tokenId": 3,
            "text": "enter",
            "partOfSpeech": "VERB",
            "score": 0.9999977350234985
        },
        {
            "tokenId": 4,
            "text": "my",
            "partOfSpeech": "PRON",
            "score": 0.9999768733978271
        },
        {
            "tokenId": 5,
            "text": "weight",
            "partOfSpeech": "NOUN",
            "score": 0.9998605251312256
        },
        {
            "tokenId": 6,
            "text": "on",
            "partOfSpeech": "ADP",
            "score": 0.9905756711959839
        },
        {
            "tokenId": 7,
            "text": "26th",
            "partOfSpeech": "NOUN",
            "score": 0.6818108558654785
        },
        {
            "tokenId": 8,
            "text": "may",
            "partOfSpeech": "AUX",
            "score": 0.9970732927322388
        }
    ]
}
*/