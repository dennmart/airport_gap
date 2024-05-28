class FavoriteSerializer
  include JSONAPI::Serializer

  attributes :airport, :note
  cache_options store: Rails.cache, namespace: 'jsonapi-serializer'
end
