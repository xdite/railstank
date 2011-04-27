SEARCH_API = IndexTank::Client.new Railstank.config["api_url"]
SEARCH_TOPIC_INDEX = SEARCH_API.indexes 'forum_topic_index'
SEARCH_USER_INDEX = SEARCH_API.indexes 'forum_user_index'