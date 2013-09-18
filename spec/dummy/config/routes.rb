Rails.application.routes.draw do
  root to: CacheParty::Engine


  mount CacheParty::Engine => "/cache_party"
  mount McpAuth::Engine => '/auth'
  mount McpCommon::Engine => '/common'
  root to: McpCommon::Engine

end
