# Contributing

To set up, run

```bash
bundle
```

To run tests,

```bash
bundle exec rspec
# or, to run continuously:
bundle exec guard
```

To see a live preview with dummy data:

```bash
bundle exec rake tricle:preview
open http://localhost:8080
```

or

```bash
bundle
cd app
rails server
open http://localhost:3000/rails/mailers/test_mailer/email
```
