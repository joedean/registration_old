fixupHeaders = ->
  $(".fc-day-header.fc-mon").html "Monday"
  $(".fc-day-header.fc-tue").html "Tuesday"
  $(".fc-day-header.fc-wed").html "Wednesday"
  $(".fc-day-header.fc-thu").html "Thursday"
  $(".fc-day-header.fc-fri").html "Friday"
  $(".fc-day-header.fc-sat").html "Saturday"

$ ->
  $("#courseCalendar").fullCalendar
    header: {
      left: "",
      center: "",
      right: ""
    }
    defaultView: "agendaWeek",
    hiddenDays: [0],                 # hide sunday
    allDaySlot: false,
    minTime: "09:00:00",
    maxTime: "22:00:00",
    eventSources: [ {
      url: "/courses.json"
      color: "pink"
      textColor: "black"
    } ]

  fixupHeaders()