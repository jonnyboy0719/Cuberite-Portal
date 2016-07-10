
function renderGuiForm()
  form = [[

  ]]

  return form
end

function renderIniSection(config)
  return [[
    <div class='preview__item'>
      <textarea name="name" id="" cols="30" rows="10" disabled>
      ]] .. config .. [[
      </textarea >
      <button class='preview__edit'>Edit</button>
      <button class='preview__del'>Del</button>
    </div>
  ]]
end
