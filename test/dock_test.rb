require "minitest/autorun"
require "minitest/pride"
require "mocha/minitest"
require "../lib/boat"
require "../lib/renter"
require "../lib/dock"

class DockTest < Minitest::Test
  def test_it_exists
    dock = Dock.new("The Rowing Dock", 3)

    assert_instance_of Dock, dock
  end

  def test_it_has_attributes
    dock = Dock.new("The Rowing Dock", 3)

    assert_equal "The Rowing Dock", dock.name
    assert_equal 3, dock.max_rental_time
  end

  def test_it_can_rent_boats
    dock = Dock.new("The Rowing Dock", 3)
    kayak_1 = Boat.new(:kayak, 20)
    kayak_2 = Boat.new(:kayak, 20)
    sup_1 = Boat.new(:standup_paddle_board, 15)
    patrick = Renter.new("Patrick Star", "4242424242424242")
    eugene = Renter.new("Eugene Crabs", "1313131313131313")
    dock.rent(kayak_1, patrick)
    dock.rent(kayak_2, patrick)
    dock.rent(sup_1, eugene)

    expected =  {
      kayak_1 => patrick,
      kayak_2 => patrick,
      sup_1 => eugene
    }
    # require "pry"; binding.pry

    assert_equal expected, dock.rental_log
  end

  def test_it_can_charge
    dock = Dock.new("The Rowing Dock", 3)
    kayak_1 = Boat.new(:kayak, 20)
    kayak_2 = Boat.new(:kayak, 20)
    sup_1 = Boat.new(:standup_paddle_board, 15)
    patrick = Renter.new("Patrick Star", "4242424242424242")
    eugene = Renter.new("Eugene Crabs", "1313131313131313")
    dock.rent(kayak_1, patrick)
    dock.rent(kayak_2, patrick)
    dock.rent(sup_1, eugene)
    kayak_1.add_hour
    kayak_1.add_hour

    expected = {
      :card_number => "4242424242424242",
      :amount => 40
    }

    assert_equal expected, dock.charge(kayak_1)
  end

  def test_that_hours_rented_does_not_exceed_max_time
    dock = Dock.new("The Rowing Dock", 3)
    sup_1 = Boat.new(:standup_paddle_board, 15)
    eugene = Renter.new("Eugene Crabs", "1313131313131313")
    dock.rent(sup_1, eugene)
    sup_1.add_hour
    sup_1.add_hour
    sup_1.add_hour
    sup_1.add_hour
    sup_1.add_hour

    expected = {
      :card_number => "1313131313131313",
      :amount => 45
    }

    assert_equal expected, dock.charge(sup_1)
  end
end
