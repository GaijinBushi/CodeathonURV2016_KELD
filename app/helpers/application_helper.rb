module ApplicationHelper
  def level_name(level)
    case level
      when 1
        _('Egg')
      when 2
        _('Chick')
      when 3
        _('Graduated Chick')
    end
  end

  def exp_for_next_level(level)
    case level
      when 1
        100
      when 2
        250
      when 3
        500
    end
  end
end
