const moment = require('moment');
// TODO: Create one namespace `JSUtils` and keep functions inside that only, final call will look like `JSUtils.dateToString(date, format)`
const DateToString = (date = new Date(), format = `YYYY-MM-DDTHH:mm:ss.sssZ`) => {
    return moment(date).format(format);
}
module.exports = {
    DateToString
}