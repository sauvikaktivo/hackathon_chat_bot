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
    const command = {
        TextList: [text],
        LanguageCode: 'en'
    }
    comprehend.batchDetectKeyPhrases(command, (err, data) => {
        if (err) {
            //console.log(`Error in batchDetectKeyPhrases ${err}`)
            completion(err,null)
        } else {
            //console.log(`Success in batchDetectKeyPhrases ${data}`)
            completion(null,data)
        }
    })
}

module.exports = {
    detectKeyPhrases,
}