const AWS = require('aws-sdk');

AWS.config.loadFromPath('./config/credentials.json');

var comprehend = new AWS.Comprehend({
    appVersion: '2017-11-27',
    region: 'us-east-1'
})


const detectKeyPhrases = async(text, completion) => {
    // https://docs.aws.amazon.com/sdk-for-javascript/v2/developer-guide/getting-started-nodejs.html
    // https://docs.aws.amazon.com/comprehend/latest/dg/supported-languages.html
    // https://docs.aws.amazon.com/AWSJavaScriptSDK/latest/AWS/Comprehend.html#batchDetectKeyPhrases-property
    const result = {}
    const command = {
        Text: text,
        LanguageCode: 'en'
    }
    comprehend.detectEntities(command, (err, data) => {
        if (data) {
            result.entities = data
            comprehend.detectKeyPhrases(command, (err, data) => {
                if(data) {
                    result.phrases = data
                    completion(null, result)
                } else {
                    completion(error, null)
                }
            })
        } else {
            completion(error, null)
        }
    })
}

module.exports = {
    detectKeyPhrases,
}