defmodule KaffyTest do
  use ExUnit.Case
  doctest Kaffy
  alias KaffyTest.Schemas.{Person, Pet}

  test "greets the world" do
    assert Kaffy.hello() == :world
  end

  test "creating a person" do
    person = %Person{}
    assert is_nil(person.name)
    assert person.married == false
  end

  test "creating a pet" do
    pet = %Pet{}
    assert pet.type == "feline"
    assert is_nil(pet.name)
  end
end
