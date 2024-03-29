locals {
  users = [
    {
      name                     = "jose"
      plain_text_passwd        = "text"
      shell                    = "/bin/bash"
      sudo                     = "ALL=(ALL) NOPASSWD:ALL"
      lock_passwd              = false
      ssh_authorized_keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDDNnLGuv5fNmFO0TdSYW4tcbnRphIa/s5NCT3+MZTtw3rHutBbSr91F/L0XU4L4Ig2r+vb65bawkNapkYNo0xaOkjlWEb9ci6u6u6AVbqSLbLB8FpiN6A8hwjopaHX9ag2myDcGBhF70zDC7ryqke2E3lV4m8WMpoueJPiQVmIURfHsYk4KzsBX0BcuBd3W3ZF5A+/p76lmBE66UaSAZCkG8gR48FA8d4wF/jI1Xnl1VObFA89h5LZ2G7tbDU/fNPYD0flB2hZIAnlr/f+td1fW0nnABftiLB0+lsfmsc+P0P3eTTxAZrhI3kW81TON57+KilqfrHa9RXv0eR4nvcGurkAJggP7ckrxSShZ5vbWWsp12MO4gPolCTJpLy+iJi9R4nLk5001wC0quglQRT6UN4grwuLQXyPBNcD5JXR261lObNFLpQSodvCcTcYEO2OAsE2aU/6pPkZ7Jb5c9GYijwcrc6wssKPGJLvjtAW4XYMlZIcRaecYnRMQ7OMFa+zBhQLSd/MLebFXkpC6F+2WrpT6mLTQyG7R7An0sNOXGQ1ERqbtLrZ/mXsQ7nZz61uLP9Kk7jnzc9YgIfPEd43LKo0AffB39Yl16PdqY2jtnSQyIOLyfp1J20+XfXjBv+oJX7fHmAyG6vDsqVxB/TikE+VthKdM/D3VKQhKddjmw== jose",
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIECDS8eOGWd5cUXOE93Pdgo87p8DkTqwpd2T2yKYxB/X jlpedrosa@gmail.com"
      ]
    },
    {
      name                     = var.ssh_username
      plain_text_passwd        = "text"
      shell                    = "/bin/bash"
      sudo                     = "ALL=(ALL) NOPASSWD:ALL"
      lock_passwd = false
      ssh_authorized_keys = [ data.sshkey.communicator.public_key ]
    }
  ]
}