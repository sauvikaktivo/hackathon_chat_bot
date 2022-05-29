const { IoTEvents } = require('aws-sdk');
const AWS = require('aws-sdk');
const { isRequired } = require('nodemon/lib/utils');

AWS.config.loadFromPath('./config/credentials.json');

var comprehend = new AWS.Comprehend({
    appVersion: '2017-11-27',
    region: 'us-east-1'
})


const nlpAnalyse = async(text, completion) => {
    // https://docs.aws.amazon.com/sdk-for-javascript/v2/developer-guide/getting-started-nodejs.html
    // https://docs.aws.amazon.com/comprehend/latest/dg/supported-languages.html
    // https://docs.aws.amazon.com/AWSJavaScriptSDK/latest/AWS/Comprehend.html#batchDetectKeyPhrases-property
    const result = []
    try {
        const phraseDetectionResult = await comprehendDetectKeyPhrases(text)
        const entityDetectionResult = await comprehendDetectEntities(text)
        const syntaxDetectionResult = await comprehendDetectSyntax(text)

        completion(null, {
            phrases: phraseDetectionResult,
            entities: entityDetectionResult,
            syntaxes: syntaxDetectionResult
        })
    } catch (e) {
        completion(e, null)
    }
}

function comprehendDetectEntities(text) {
    const command = {
        Text: text,
        LanguageCode: 'en'
    }
    return new Promise((resolve, reject) => {
        if(text) {
            comprehend.detectEntities(command, (err, data) => {
                if(err) { reject(err) }
                else {
                    const result = []
                    data.Entities.forEach(item => {
                        result.push({
                            text: item.Text,
                            score: item.Score,
                            type: item.Type
                        })
                    });
                    resolve(result) 
                }
            })
        } else {
            reject('Invalid text entry')
        }
    })
}

function comprehendDetectKeyPhrases(text) {
    const command = {
        Text: text,
        LanguageCode: 'en'
    }
    return new Promise((resolve, reject) => {
        if(text) {
            comprehend.detectKeyPhrases(command, (err, data) => {
                if(err) { reject(err) }
                else {
                    const result = []
                    data.KeyPhrases.forEach(item => {
                        result.push({
                            text: item.Text,
                            score: item.Score
                        })
                    });
                    resolve(result) 
                }
            })
        } else {
            reject('Invalid text entry')
        }
    })
}

function comprehendDetectSyntax(text) {
    const command = {
        Text: text,
        LanguageCode: 'en'
    }
    return new Promise((resolve, reject) => {
        if(text) {
            comprehend.detectSyntax(command, (err, data) => {
                if(err) {reject(err)}
                else { 
                    const result = []
                    data.SyntaxTokens.forEach(item => {
                        result.push({
                            tokenId: item.TokenId,
                            text: item.Text,
                            partOfSpeech: item.PartOfSpeech.Tag,
                            score: item.PartOfSpeech.Score
                        })
                    });
                    resolve(result) 
                }
            })
        } else {
            reject('Invalid text entry')
        }
    })
}

module.exports = {
    detectKeyPhrases: nlpAnalyse,
}