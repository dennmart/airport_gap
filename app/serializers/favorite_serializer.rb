class FavoriteSerializer
  include FastJsonapi::ObjectSerializer
  attributes :airport, :note
end
