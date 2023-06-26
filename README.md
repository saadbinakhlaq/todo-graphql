# Introduction

- Features
  - [x] API to query Todos (potentially many!)
    - Query Todos that are not done
    - Todos can be grouped in lists
  - [x] API to add a Todo
  - [x] API to update Todos
    - Mark Todos as done
  - [x] We would like you to integrate with another service provider. It can be any Todo service (e.g. Microsoft Todo APIs), or you can also use a mock provider. Todos should be kept in sync between our service and the third-party integration
    - Todos created in the third-party integration should always be created in our service
    - The status of todos should always be in sync between our service and the integration


Note:

Currently there is an option to sync with an external service like Microsoft todo graph. For this the best option would be to get the access token from [here](https://developer.microsoft.com/en-us/graph/graph-explorer). After you have the access token you need to add the access token to the user.
For this you need to go to rails console
```
user = User.find_by(email: "registered@mail.com")
user.external_access_tokens.create!(provider: "microsoft", access_token: "access_token")
```

Once this is done the syncing with external service can take place.

Update of task in the external service is not done.

Things that have not been done
* Update of tasks with the external service (so if a task that is with an external service as well and it has been updated on our side, it won't get updated on the external service)
* When we sync the tasks with an external service only the name and status of the tasks are being synced. We are not syncing when the task was created on the external service. These things would just increase the scope for me for this task
* The performance when it comes to syncing can be definitely improved, currently we have a very rudimentary approach to syncing.
## Installation

We need to have docker installed for this project
```bash
docker-compose build
```
    
## Running Tests

To run tests, run the following command

```bash
  docker-compose run web bash
  $ rspec
```


## Usage/Examples

Create an account
```bash
mutation {
  signUp(input: {email: "saadbinakhlaq@outlook.com", password: "12345678"}) {
    token
  }
}
```

SignIn
```bash
mutation {
  signIn(input: {email: "saadbinakhlaq@outlook.com", password: "12345678"}) {
    token
  }
}
```

Create a task
```bash
  mutation {
    createTask(input: {name: "Test task t"}) {
      task { 
        id
      }
    }
  }
```

```bash
  mutation {
    createTask(input: {name: "Test task t", listId:"1"}) {
      task { 
        id
      }
    }
  }
```

Query tasks
```bash
query {
	userTasks {
    id
    name
    done
    list {
      id
    }
  }
}
```

Query tasks which are done
```bash
query {
	userTasks(done:true) {
    id
    name
    done
    list {
      id
    }
  }
}

```
