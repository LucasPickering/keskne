terraform {
  backend "gcs" {
    bucket = "keskne-tfstate"
    prefix = "keskne/cluster"
  }
}
