defmodule Kaffy.ResourceAdminTest do
  use ExUnit.Case
  doctest Kaffy
  alias KaffyTest.Schemas.{Person}
  alias KaffyTest.Admin.PersonAdmin

  describe "Kaffy.ResourceAdmin" do
    alias Kaffy.ResourceAdmin

    test "index/1 should return a keyword list of fields and their values" do
      assert Kaffy.ResourceSchema.index_fields(Person) == ResourceAdmin.index(schema: Person)
      custom_index = ResourceAdmin.index(schema: Person, admin: PersonAdmin)
      assert [:name, :married] == Keyword.keys(custom_index)
    end
  end
end
