spa_card_model  = require '../models/spa_card'

save = (params, done) ->
  console.log "params", params
  spa_card_db = new spa_card_model params
  spa_card_db.save done


module.exports = {
  save
}
