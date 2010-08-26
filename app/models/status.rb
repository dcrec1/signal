module Status
  SUCCESS   = "success"
  FAIL      = "failure"
  RUNNING   = "running"

  def status
    success ? SUCCESS : FAIL
  end
end
