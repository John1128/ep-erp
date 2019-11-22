class ClienteSerializer < ActiveModel::Serializer
  attributes :id,:razon_social, :rfc,:telefono,:email,:estado,:municipio,:colonia,:codigo_postal,:calle,:numero_exterior,:numero_interior,:localidad,:referencia,:pais_id

  def estado
      object.municipio.estado.nombre
  end

  def municipio
      object.municipio.nombre
  end

end
