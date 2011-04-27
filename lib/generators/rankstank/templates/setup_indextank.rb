file = File.read("#{Rails.root}/config/indextank.yml")
indextank_config = YAML.load(file)[Rails.env]

SEARCH_API = IndexTank::Client.new indextank_config["api_url"]
SEARCH_TOPIC_INDEX = SEARCH_API.indexes 'forum_topic_index'
SEARCH_USER_INDEX = SEARCH_API.indexes 'forum_user_index'