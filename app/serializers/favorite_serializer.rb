class FavoriteSerializer
  include JSONAPI::Serializer

  attributes :airport, :note
end
