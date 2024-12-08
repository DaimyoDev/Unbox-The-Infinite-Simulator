local function repeatForever()
    task.wait(1)
    print("Hello again!")
    repeatForever()
end

repeatForever()