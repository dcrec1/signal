module Status
  SUCCESS   = "success"
  FAIL      = "failure"

  def status
    success ? SUCCESS : FAIL
  end
end
