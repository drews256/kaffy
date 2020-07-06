defmodule Kaffy.ResourceSchemaTest do
  use ExUnit.Case
  doctest Kaffy
  alias KaffyTest.Schemas.{Person, Pet}

  describe "Kaffy.ResourceSchema" do
    alias Kaffy.ResourceSchema
    alias Kaffy.ResourceForm

    test "excluded_fields should return primary keys" do
      assert [:id] == ResourceSchema.excluded_fields(Person)
      assert [:id] == ResourceSchema.excluded_fields(Pet)
    end

    test "primary_key/1 should return a list of primary keys" do
      assert [:id] == ResourceSchema.primary_key(Person)
      assert [:id] == ResourceSchema.primary_key(Pet)
    end

    test "kaffy_field_name/2 should return the name of the field" do
      assert "Address" == ResourceSchema.kaffy_field_name(nil, :address)
      assert "Created At" == ResourceSchema.kaffy_field_name(nil, :created_at)
      person = %Person{name: "Abdullah"}
      f = {:status, %{name: "Yes"}}
      assert "Yes" == ResourceSchema.kaffy_field_name(person, f)
      f = {:status, %{name: fn p -> String.upcase(p.name) end}}
      assert "ABDULLAH" == ResourceSchema.kaffy_field_name(person, f)
      f = {:status, %{value: "something"}}
      assert "Status" == ResourceSchema.kaffy_field_name(person, f)
    end

    test "kaffy_field_value/2 should return the value of the field" do
      person = %Person{name: "Abdullah"}
      assert "Abdullah" == ResourceSchema.kaffy_field_value(person, :name)
      field = {:name, %{value: "Esmail"}}
      assert "Esmail" == ResourceSchema.kaffy_field_value(person, field)
      field = {:name, %{value: fn p -> "Mr. #{p.name}" end}}
      assert "Mr. Abdullah" == ResourceSchema.kaffy_field_value(person, field)
      field = {:name, %{name: fn p -> "Mr. #{p.name}" end}}
      assert "Abdullah" == ResourceSchema.kaffy_field_value(person, field)
    end

    test "fields/1 should return all the fields of a schema without associations" do
      fields = ResourceSchema.index_fields(Person)
      assert is_list(fields)
      assert Enum.all?(fields, fn field ->
        {field_name, _options} = field
        is_atom(field_name)
      end)
      [{first_field_name, _options} | _] = fields
      assert first_field_name == :id
      assert length(fields) == 6
    end

    test "associations/1 must return all associations for the schema" do
      associations = ResourceSchema.associations(Person)
      assert [:pets] == associations
      pet_assoc = ResourceSchema.associations(Pet)
      assert [:person] == pet_assoc
    end

    test "association/1 must return information about the association" do
      person_assoc = ResourceSchema.association(Person, :pets)
      assert Ecto.Association.Has == person_assoc.__struct__
      assert person_assoc.cardinality == :many
      assert person_assoc.queryable == Pet

      pet_assoc = ResourceSchema.association(Pet, :person)
      assert Ecto.Association.BelongsTo == pet_assoc.__struct__
      assert pet_assoc.cardinality == :one
      assert pet_assoc.queryable == Person
    end

    test "association_schema/2 must return the schema of the association" do
      assert Pet == ResourceSchema.association_schema(Person, :pets)
      assert Person == ResourceSchema.association_schema(Pet, :person)
    end

    test "form_label/2 should return a label tag" do
      {:safe, label_tag} = ResourceForm.form_label(:user, "My name")
      assert is_list(label_tag)
      label_string = to_string(label_tag)
      assert String.contains?(label_string, "<label")
      assert String.contains?(label_string, "user")
      assert String.contains?(label_string, "My name")
    end
  end
end
