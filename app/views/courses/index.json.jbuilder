json.array! @courses do |course|
  json.(course, :id, :studio)
  json.set! :title, course.name
  json.set! :start, course.start_at
  json.set! :end, course.end_at
end