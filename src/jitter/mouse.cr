require "log"

module Jitter
  class Mouse
    MOUSE_POINTER_INCREMENT_X = 1 # How many pixels to reposition the mouse cursor by on the x-axis
    MOUSE_POINTER_INCREMENT_Y = 1 # How many pixels to reposition the mouse cursor by on the y-axis

    # Creates a new Mouse object for repositioning the mouse slightly if it hasn't moved
    def initialize
      @previous_position = @current_position = LibUser32::Point.new(x: 0, y: 0)
      @screen_width = @screen_height = 0..1
      @random = Random.new
    end

    # Will move the mouse by 1 pixel diagonally and back to its original position
    # if the mouse has not moved since the last reposition
    def reposition_if_inert
      # refresh screen dimensions and current mouse position
      refresh_all

      Log.info { "Status:     #{to_s}" }

      # if the mouse has not moved, then reposition it by 1 pixel then return it to its original position
      if (current_position = @current_position) && (previous_position = @previous_position) && current_position == previous_position
        delta = calculate_delta

        # move mouse by delta
        move(delta.x, delta.y)
        new_position = get_position()

        # undo mouse move by negating the delta
        move(delta.x * -1, delta.y * -1)
        original_position = get_position()

        Log.info { "Reposition: position = #{to_s current_position} -> #{to_s new_position} -> #{to_s original_position}" }
      else
        @previous_position = @current_position
      end
    end

    # Returns the screen dimensions and last known position of the mouse as a string
    def to_s
      "position = #{to_s @current_position}, screen = #{@screen_width.end}x#{@screen_height.end}"
    end

    # Returns the given point as a string
    private def to_s(position : LibUser32::Point) : String
      "(x = #{position.x}, y = #{position.y})"
    end

    # Moves the position of the mouse by the given delta on the x and y axis
    private def move(dx : Int32, dy : Int32) : Nil
      inputs = uninitialized LibUser32::Input[1]
      inputs[0] = LibUser32::Input.new(type: LibUser32::InputType::Mouse, event: LibUser32::InputEvent.new(mi: LibUser32::MouseInput.new(dx: dx, dy: dy, mouse_data: 0, dw_flags: LibUser32::MouseEventFlags::Move, time: 0, dw_extra_info: 0)))
      result = LibUser32.SendInput(inputs.size, inputs.to_unsafe, sizeof(LibUser32::Input))
      raise "Position not set" unless result == inputs.size
    end

    # Refreshes the screen dimensions and the current mouse position
    private def refresh_all : Nil
      # refresh primary screen dimensions
      refresh_screen_dimensions
      # refresh current mouse position
      refresh_position
    end

    # Refreshes the virtual screen dimensions
    private def refresh_screen_dimensions : Nil
      # refresh virtual screen dimensions
      @screen_width = LibUser32.GetSystemMetrics(LibUser32::SystemMetric::VirtualScreenX)..LibUser32.GetSystemMetrics(LibUser32::SystemMetric::VirtualScreenWidth)
      @screen_height = LibUser32.GetSystemMetrics(LibUser32::SystemMetric::VirtualScreenY)..LibUser32.GetSystemMetrics(LibUser32::SystemMetric::VirtualScreenHeight)
    end

    # Refreshes the current mouse position
    private def refresh_position : Nil
      @current_position = get_position()
    end

    # Refreshes the current mouse position
    private def get_position : LibUser32::Point
      position = uninitialized LibUser32::Point
      LibUser32.GetCursorPos(pointerof(position))
      position
    end

    # Returns a new random delta from the current position of the mouse to reposition the mouse to
    private def calculate_delta : LibUser32::Point
      delta = LibUser32::Point.new
      if (current_position = @current_position) && (screen_width = @screen_width) && (screen_height = @screen_height) && (random = @random)
        # calculate the x-axis delta so that it is random unless it is at the extremities of the screen width
        if current_position.x == screen_width.begin
          delta.x = MOUSE_POINTER_INCREMENT_X
        elsif current_position.x == screen_width.end
          delta.x = MOUSE_POINTER_INCREMENT_X * -1
        else
          delta.x = random.next_bool ? MOUSE_POINTER_INCREMENT_X * -1 : MOUSE_POINTER_INCREMENT_X
        end

        # calculate the y-axis delta so that it is random unless it is at the extremities of the screen height
        if current_position.y == screen_height.begin
          delta.y = MOUSE_POINTER_INCREMENT_Y
        elsif current_position.y == screen_height.end
          delta.y = MOUSE_POINTER_INCREMENT_Y * -1
        else
          delta.y = random.next_bool ? MOUSE_POINTER_INCREMENT_Y * -1 : MOUSE_POINTER_INCREMENT_Y
        end
      end
      delta
    end
  end

  @[Link("User32")]
  lib LibUser32
    struct Point
      x, y : LibC::LONG
    end

    enum SystemMetric : UInt32
      VirtualScreenX      = 76 # SM_XVIRTUALSCREEN
      VirtualScreenY      = 77 # SM_YVIRTUALSCREEN
      VirtualScreenWidth  = 78 # SM_CXVIRTUALSCREEN
      VirtualScreenHeight = 79 # SM_CXVIRTUALSCREEN
    end

    enum MouseEventFlags : UInt32
      Move = 0x0001 # MOUSEEVENTF_MOVE
    end

    enum InputType : UInt32
      Mouse = 0 # INPUT_MOUSE
    end

    struct MouseInput
      dx : Int32
      dy : Int32
      mouse_data : UInt32
      dw_flags : MouseEventFlags
      time : UInt32
      dw_extra_info : LibC::UINT_PTR
    end

    union InputEvent
      mi : MouseInput
    end

    struct Input
      type : InputType
      event : InputEvent
    end

    fun GetCursorPos(lpPoint : Point*)
    fun SetCursorPos(x : Int32, y : Int32) : LibC::BOOL
    fun GetSystemMetrics(nIndex : SystemMetric) : Int32
    fun SendInput(cInputs : UInt32, pInputs : Input*, cbSize : Int32) : UInt32
  end
end
